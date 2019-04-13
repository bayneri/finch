const vision = require('@google-cloud/vision');
const client = new vision.ImageAnnotatorClient();

// Performs text detection on the local file
const getCenter = function (points) {
    return points.reduce(function (sum, p) {
        return { x: sum.x + p.x / 4, y: sum.y + p.y / 4 }
    }, { x: 0, y: 0 })
}
const getSlope = function (p1, p2) {
    return (p2.y - p1.y) / (p2.x - p1.x);
}

const getPrice = function (str) {
    let t = ""
    str = str.trim()
    for (let i = str.length - 1; i >= 0; i--) {
        if ('0123456789'.includes(str[i]) || str[i] == ',') {
            t += str[i]
        }
        else if (str[i] == ' ') {
            if (str[i - 1] == ',' || str[i + 1] == ',') continue
            else break
        }
        else break

    }
    let ret = ""
    for (let i = t.length - 1; i >= 0; i--) {
        ret += t[i];
    }
    return ret
}

const ocrService = (fileName, totalPrice) => {
    return client.textDetection(fileName)
        .then(res => {
            // console.log(res)
            let products = []
            let tokens = res[0].textAnnotations.slice(1)

            let bef = Array(tokens.length)
            let aft = Array(tokens.length)
            let vis = Array(tokens.length)

            tokens.forEach((element, i) => {
                let points = element.boundingPoly.vertices
                let center = getCenter(points)
                let p1 = { x: (points[0].x + points[3].x) / 2, y: (points[0].y + points[3].y) / 2 }
                let p2 = { x: (points[1].x + points[2].x) / 2, y: (points[1].y + points[2].y) / 2 }
                let slope = getSlope(p1, p2)
                const threshold = 0.082

                let closestElement = {}

                let f = 0
                tokens.forEach((nextElement, j) => {

                    let nextCenter = getCenter(nextElement.boundingPoly.vertices)
                    let slopeDiff = slope - getSlope(center, nextCenter)

                    if (nextElement !== element) {
                        // console.log('-------------------------------------------------------------')
                        // console.log(nextElement.description)
                        // console.log(slopeDiff)

                        if (Math.abs(slopeDiff) < threshold && nextCenter.x > center.x) {
                            // console.log(closestElement)
                            if (!Object.keys(closestElement).length ||
                                getCenter(closestElement.boundingPoly.vertices).x > nextCenter.x) {

                                f = j
                                closestElement = nextElement
                            }
                        }
                    }
                })

                if (Object.keys(closestElement).length) {
                    aft[i] = f
                    bef[f] = i
                }
            })

            chains = []

            for (let i = 0; i < tokens.length; i++) {
                let chain = []
                if (!vis[i]) {
                    let temp = i;
                    let flag = false
                    while (bef[temp] >= 0) {
                        temp = bef[temp]
                    }
                    while (temp >= 0) {
                        chain.push(tokens[temp])
                        vis[temp] = true
                        temp = aft[temp]
                    }
                    chains.push(chain)
                }

            }

            chains.sort(function (c1, c2) {
                return getCenter(c1[0].boundingPoly.vertices).y - getCenter(c2[0].boundingPoly.vertices).y
            })

            chains.forEach(chain => {
                let numCnt = 0
                let numLet = 0
                let line = ""
                chain.forEach(elem => {
                    for (i in elem.description) {
                        let c = elem.description[i]
                        if ('0123456789'.includes(c)) {
                            numCnt++
                        }
                    }
                    line += elem.description + ' '
                })

                if (line.includes(',') && '0123456789'.includes(line[line.length - 2]) && numCnt > 0) {

                    let name = ""
                    let price = getPrice(line)
                    let flag = false
                    line = line.trim()
                    // console.log(line)

                    for (i in line) {
                        c = line[i]
                        if (('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') || c == 'İ' || c == 'İ' || c == 'ı' || c == 'Ö' || c == 'ö' || c == 'Ç' || c == 'ç' || c == 'Ş' || c == 'ş' || c == 'Ü' || c == 'ü' || c == 'ğ' || c == 'Ğ'
                            || ('0123456789'.includes(c)) || c == '-' || c == ' ') {
                            name += c
                        }
                        else break

                    }
                    let numCnt = 0
                    let numLet = 0
                    for (i in name) {
                        let c = name[i]
                        if ('0123456789'.includes(c)) {
                            numCnt++
                        }
                        else if (('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z')) {
                            numLet++;
                        }
                    }

                    if (numLet > numCnt + 2)
                        products.push({ name: name, price: price.replace(',', '.') })
                }
            });

            res = []

            if (!totalPrice) {
                totalPrice = 0;
                for (let k = 0; k < products.length; k++) {
                    totalPrice = totalPrice >= parseFloat(products[k].price) ? totalPrice : parseFloat(products[k].price);
                }
            }

            for (let i = 0; i < (1 << products.length); i++) {
                let sum = 0.0
                for (let k = 0; k < products.length; k++) {
                    if ((1 << k) & i) {
                        sum += parseFloat(products[k].price)
                    }
                }
                if (Math.abs(sum - totalPrice) < 0.001) {
                    for (let k = 0; k < products.length; k++) {
                        if ((1 << k) & i) {
                            res.push({ name: products[k].name, price: parseFloat(products[k].price) })
                        }
                    }
                    break
                }
            }
            return res
        })
}

module.exports = ocrService