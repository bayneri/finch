from flask import Flask
import pickle
from gensim.models import KeyedVectors
import numpy as np
import json
from urllib.parse import unquote


word_vectors = KeyedVectors.load_word2vec_format('trmodel', binary=True)
clf = pickle.load(open("classifier.sav", 'rb'))
category_in_mapping = {0: 'Şekersiz Tatlandırıcılı Ürünler', 1: 'Sıvı Yağlar', 2: 'Çamaşır Gereçleri', 3: 'Yoğurt', 4: 'Çikolata, Gofret', 5: 'Gazlı İçecekler', 6: 'Süt', 7: 'Çay, Kahve', 8: 'Ev Temizlik Gereçleri', 9: 'Banyo Gereçleri', 10: 'Hijyenik Pedler', 11: 'Anne Ürünleri', 12: 'Kırmızı Et', 13: 'Makyaj Ve Süs Ürünleri', 14: 'Günlük İçecek', 15: 'Şeker', 16: 'Bisküvi, Çerez', 17: 'Yumurta', 18: 'Hazır Yemek, Konserve, Salça', 19: 'Meze', 20: 'Sular', 21: 'Kişisel İlgi, Eğlence', 22: 'Dondurma', 23: 'Çorba Ve Bulyonlar', 24: 'Ağdalar, Tüy Dökücüler', 25: 'Peynir', 26: 'Bulaşık Yıkama', 27: 'Bebek Ürünleri', 28: 'Meyve', 29: 'Tıraş Malzemeleri', 30: 'Bahçe, Çiçek, Kamp, Piknik', 31: 'Sağlık Ürünleri', 32: 'Kitap, Dergi, Kırtasiye', 33: 'Tuz, Baharat, Harç', 34: 'Elektrik, Elektronik', 35: 'Oyuncaklar', 36: 'Ev Temizlik Ürünleri', 37: 'Vücut, Cilt Bakım', 38: 'Ağız Bakım Ürünleri', 39: 'Çamaşır Yıkama', 40: 'Kağıt Ürünleri', 41: 'Bebek Bezi', 42: 'Kümes Hayvanları', 43: 'Sütlü Tatlı, Krema', 44: 'Parfüm, Deodorant', 45: 'Ev, Ofis, Bahçe Dekorasyon', 46: 'Pet Ürünleri', 47: 'Tekstil, Giyim, Aksesuar', 48: 'Sebze', 49: 'Duş, Banyo, Sabun', 50: 'Mutfak Eşya, Gereçleri', 51: 'Tereyağ, Margarin', 52: 'Sağlıklı Yaşam Ürünleri', 53: 'Unlu Mamül, Tatlı', 54: 'Kahvaltılıklar', 55: 'Maden Suları', 56: 'Saç Bakım', 57: 'Sakız, Şekerleme', 58: 'Gazsız İçecekler', 59: 'Dondurulmuş Gıda', 60: 'Bakliyat, Makarna', 61: 'Benzin', 62: 'Sigara', 63: 'Alkol', 64: 'Restoran'}
app = Flask(__name__)
@app.route('/<tags>')
def hello_world(tags):
    print(tags)
    tags = unquote(tags)
    threshold = 0
    lists = []
    for tag in tags.split("$$$"):
        word_lower = set(tag.lower().split())
        if "kola" in word_lower:
            lists.append("Gazlı İçecekler")
            continue
        if len({"benzin", "motorin", "kursunsuz", "kurşunsuz"}.intersection(word_lower))>0:
            lists.append("Benzin")
            continue
        if len({"parliament", "marlboro", "camel", "winston", "sigara", "rothmans", "sig."}.intersection(word_lower))>0:
            lists.append("Sigara")
            continue
        if len({"bira", "rakı", "alkol", "şarap", "viski", "votka", "tekila", "chivas", "konyak"}.intersection(word_lower))>0:
            lists.append("Alkol")
            continue
        
        
        c = 0
        x = np.zeros(400)
        for w in word_lower:
            if w in word_vectors:
                c += 1
                x += word_vectors[w]
        if c==0:
            lists.append("None")
            continue
        x = x/c
        probs = clf.predict_proba(x.reshape(1,-1))
        if max(probs[0])>threshold:
            lists.append(category_in_mapping[np.argmax(probs)])
        else:
            lists.append("None")
        
    print(tags.split("$$$"), lists)
    return json.dumps(lists, ensure_ascii=False)