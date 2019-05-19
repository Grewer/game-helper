# -*- coding:UTF-8 -*-
import execjs  # 必须，需要先用pip 安装，用来执行js脚本
from bs4 import BeautifulSoup
import requests
from PIL import Image,ImageEnhance,ImageFilter
import json
import urllib
import pytesseract
import sys
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='gb18030') 
import sys  


def image_to_string(image):
    return pytesseract.image_to_string(image, lang='jpn')
print('run start')

# 二值化  
threshold = 140  
table = []  
for i in range(256):  
    if i < threshold:  
        table.append(0)  
    else:  
        table.append(1)  
  
def  getverify1(name):        
    #打开图片  
	im = Image.open(name)  
    #转化到灰度图
	imgry = im.convert('L')
    #保存图像
	imgry.save(name)  
    #二值化，采用阈值分割法，threshold为分割点 
	out = imgry.point(table,'1')  
	out.save(name)  
    #识别  
	text = image_to_string(out)  
    #识别对吗  
	text = text.strip()  
	text = text.upper()
	return text  
text = getverify1('C:\\Users/Admin/Desktop/1.PNG')

print('text start')
print(text)
print('text end')

# if pytesseract env is none
# pytesseract.pytesseract.tesseract_cmd = '/usr/local/Cellar/tesseract/4.0.0_1/bin/tesseract'
# text = pytesseract.image_to_string(Image.open('/Users/admin/grewer/py/testEng.png'), lang='eng')
# text = pytesseract.image_to_string(Image.open('/Users/admin/grewer/py/testEng.png'), lang='eng')
# text = pytesseract.image_to_string(Image.open('C:\\Users/Admin/Desktop/buhuo.PNG'), lang='jpn')
# text = pytesseract.image_to_string(Image.open('C:\\Users/Admin/Desktop/1.PNG'), lang='jpn')
# text = pytesseract.image_to_string(Image.open('C:\\Users/Admin/Desktop/testJpn.jpg'), lang='jpn')




# print('text start')
# print(text)
# print('text end')

# 有道
# req_url = 'http://fanyi.youdao.com/translate'  # 创建连接接口
# # 创建要提交的数据
# Form_Date = {}
# Form_Date['i'] = text  # 要翻译的内容可以更改
# Form_Date['doctype'] = 'json'

# data = urllib.urlencode(Form_Date).encode('utf-8') #数据转换
# response = urllib.urlopen(req_url, data) #提交数据并解析
# html = response.read().decode('utf-8')  #服务器返回结果读取
# # print(html)
# # 可以看出html是一个json格式
# translate_results = json.loads(html)  #以json格式载入
# translate_results = translate_results['translateResult'][0][0]['tgt']  # json格式调取
# print(translate_results) #输出结果


class Py4Js():
	def __init__(self):
		self.ctx = execjs.compile("""
		function TL(a) {
		var k = "";
		var b = 406644;
		var b1 = 3293161072;
		var jd = ".";
		var $b = "+-a^+6";
		var Zb = "+-3^+b+-f";
		for (var e = [], f = 0, g = 0; g < a.length; g++) {
			var m = a.charCodeAt(g);
			128 > m ? e[f++] = m : (2048 > m ? e[f++] = m >> 6 | 192 : (55296 == (m & 64512) && g + 1 < a.length && 56320 == (a.charCodeAt(g + 1) & 64512) ? (m = 65536 + ((m & 1023) << 10) + (a.charCodeAt(++g) & 1023),
			e[f++] = m >> 18 | 240,
			e[f++] = m >> 12 & 63 | 128) : e[f++] = m >> 12 | 224,
			e[f++] = m >> 6 & 63 | 128),
			e[f++] = m & 63 | 128)
		}
		a = b;
		for (f = 0; f < e.length; f++) a += e[f],
		a = RL(a, $b);
		a = RL(a, Zb);
		a ^= b1 || 0;
		0 > a && (a = (a & 2147483647) + 2147483648);
		a %= 1E6;
		return a.toString() + jd + (a ^ b)
	  };
	  function RL(a, b) {
		var t = "a";
		var Yb = "+";
		for (var c = 0; c < b.length - 2; c += 3) {
			var d = b.charAt(c + 2),
			d = d >= t ? d.charCodeAt(0) - 87 : Number(d),
			d = b.charAt(c + 1) == Yb ? a >>> d: a << d;
			a = b.charAt(c) == Yb ? a + d & 4294967295 : a ^ d
		}
		return a
	  }
	 """)

	def getTk(self, text):
		return self.ctx.call("TL", text)

def buildUrl(text, tk):
	baseUrl = 'https://translate.google.cn/translate_a/single'
	baseUrl += '?client=t&'
	baseUrl += 's1=auto&'
	baseUrl += 't1=zh-CN&'
	baseUrl += 'h1=zh-CN&'
	baseUrl += 'dt=at&'
	baseUrl += 'dt=bd&'
	baseUrl += 'dt=ex&'
	baseUrl += 'dt=ld&'
	baseUrl += 'dt=md&'
	baseUrl+='dt=qca&'
	baseUrl+='dt=rw&'
	baseUrl+='dt=rm&'
	baseUrl+='dt=ss&'
	baseUrl+='dt=t&'
	baseUrl+='ie=UTF-8&'
	baseUrl+='oe=UTF-8&'
	baseUrl+='otf=1&'
	baseUrl+='pc=1&'
	baseUrl+='ssel=0&'
	baseUrl+='tsel=0&'
	baseUrl+='kc=2&'
	baseUrl+='tk='+str(tk)+'&'
	baseUrl+='q='+text
	return baseUrl
def translate(text):
	header={
	'authority':'translate.google.cn',
	'method':'GET',
	'path':'',
	'scheme':'https',
	'accept':'*/*',
	'accept-encoding':'gzip, deflate, br',
	'accept-language':'zh-CN,zh;q=0.9',
	'cookie':'',
	'user-agent':'Mozilla/5.0 (Windows NT 10.0; WOW64)  AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36',
	'x-client-data':'CIa2yQEIpbbJAQjBtskBCPqcygEIqZ3KAQioo8oBGJGjygE='
	}
	url=buildUrl(text,js.getTk(text))
	res=''
	try:
		r=requests.get(url)
		result=json.loads(r.text)
		if result[7]!=None:
			# 如果我们文本输错，提示你是不是要找xxx的话，那么重新把xxx正确的翻译之后返回
			try:
				correctText=result[7][0].replace('<b><i>',' ').replace('</i></b>','')
				print(correctText)
				correctUrl=buildUrl(correctText,js.getTk(correctText))
				correctR=requests.get(correctUrl)
				newResult=json.loads(correctR.text)
				res=newResult[0][0][0]
			except Exception as e:
				print(e)
				res=result[0][0][0]
		else:
				res=result[0][0][0]
	except Exception as e:
		res=''
		print(url)
		print("翻译"+text+"失败")
		print("错误信息:")
		print(e)
	finally:
		return res

js=Py4Js()

res=translate(text)
print(res)
