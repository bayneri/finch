# Finch
![finch](https://github.com/bayneri/finch/blob/master/assets/logo_text.png)
#### [Kuveyt Türk Hackathon](http://www.kt-invent.com.tr) 2019 - Üçüncülük (_*Yaklaşık 24 saatte geliştirilmiştir.*_)

Kullanıcıların harcamalarını takip edebileceği, kredi kartlarıyla entegre çalışacak, fiş tarama özelliğiyle harcamalarının alt kırılımlarını da anlayabilen ve kullanıcıya birikim hedefleri sunacak akıllı bir asistana sahip Mobil Uygulama.

Bunun yanı sıra fiş tarama özelliği ve geliştirdiğimiz algoritmalar sayesinde bireysel harcamalara dair bankaların ve kullanıcaların sahip olduğundan çok daha fazla bilgiyi işleyip, kullanıcıların hem uygulamamızla hem de bankasıyla arasındaki deneyimi iyileştirmeyi hedefliyoruz.

## Ürün
![Ürün](https://github.com/bayneri/finch/blob/master/assets/product.jpg)

## Ekran Görüntüleri
||||
:-------------------------:|:-------------------------:|:-------------------------:
![ss1](https://github.com/bayneri/finch/blob/master/assets/ss_1.png) | ![ss2](https://github.com/bayneri/finch/blob/master/assets/ss_2.png) | ![ss3](https://github.com/bayneri/finch/blob/master/assets/ss_3.png)
![ss4](https://github.com/bayneri/finch/blob/master/assets/ss_4.png) | ![ss5](https://github.com/bayneri/finch/blob/master/assets/ss_5.png) | ![ss6](https://github.com/bayneri/finch/blob/master/assets/ss_6.png)
![ss7](https://github.com/bayneri/finch/blob/master/assets/ss_7.png) | ![ss8](https://github.com/bayneri/finch/blob/master/assets/ss_8.png) | ![ss9](https://github.com/bayneri/finch/blob/master/assets/ss_9.png)


## Fatura Tanıma & Alt Kırılım Sınıflandırma

![Fatura Tanıma & Alt Kırılım Sınıflandırma](https://github.com/bayneri/finch/blob/master/assets/image-process.jpg)

### Fatura Tanıma
Google Cloud Vision API'dan gelen cevap üzerinden connected component'lar çıkarılıp, linear programlamayla ürün-fiyat eşleştirmesi yapıldı

![Fatura Tanıma](https://github.com/bayneri/finch/blob/master/assets/ocr.jpg)

### Alt Kırılım Sınıflandırma
Bu problem için farklı alışveriş kaynaklarından 65 farklı kategori için 20.000 ürün eğitim verisi olarak hazırlanıldı. Hybrid bir yaklaşımla(makine öğrenmesi, kurala dayalı) oluşan modelimiz gelen ürün için kategori tahmininde bulunuyor.

Test başarı oranımız %78.

![Fatura Tanıma & Alt Kırılım Sınıflandırma](https://github.com/bayneri/finch/blob/master/assets/classification.jpg)


### [Final Sunumu](https://github.com/bayneri/finch/blob/master/assets/presentation.pdf)
### [Video Demo](https://www.youtube.com/watch?v=vZneJ75OdUA&feature=youtu.be)>>

## Takım
| [Enes Çakır](https://github.com/enescakir) 	| [Halil Çetiner](https://github.com/bayneri) 	| [Alperen Yakut](https://github.com/ayakut16) 	| [Abdullatif Köksal](https://github.com/akoksal) 	|
|------	|-------	|---------	|-------	|

![Takım](https://github.com/bayneri/finch/blob/master/assets/team.jpg)
