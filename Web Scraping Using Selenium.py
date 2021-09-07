#!/usr/bin/env python
# coding: utf-8

# WEB SCRAPING BY USING SELENIUM

# In[1]:


import selenium
from selenium import webdriver
import time
from bs4 import BeautifulSoup
import pandas as pd


# In[2]:


def get_url(product): # function for url template
    product = product.replace(' ','+')
    template = 'https://www.prestomall.com/totalsearch/TotalSearchAction/searchTotal.do?targetTab=T&isGnb=Y&prdType=&category=&cmd=&pageSize=60&lCtgrNo=0&mCtgrNo=0&sCtgrNo=0&ctgrType=&fromACK=&gnbTag=TO&schFrom=&tagetTabNm=T&aKwdTrcNo=&aUrl=&kwd={}&callId=9375ea7eb484cb2ae2a'
    url = template.format(product)
    return url

def get_all_products(card): # function to get products details
    productimg = card.find('img','product-item-image lazyloaded')
    product_image = productimg['src'] # source of product image
    
    test_str = card.a.get('title')
    test_str = test_str.encode('ascii','ignore')
    product_name = str(test_str,'utf-8').strip() # remove emoji from product name
    
    product_price = card.find('p','product-item-selling-price').text
    
    anchor_tag = card.a.get('href')
    product_link = 'https://www.prestomall.com' + anchor_tag
    
    product_info = (product_image, product_name, product_price, product_link)
    
    return product_info

def main(product):
    records = []
    url = get_url(product)
    
    driver = webdriver.Chrome(executable_path='C:\chromedriver\\chromedriver.exe')
    
    driver.get(url)
    time.sleep(3)
    driver.maximize_window()
    
    #Define an initial value
    temp_height=0
    
    
    while True:
        #Looping down the scroll bar
        driver.execute_script("window.scrollBy(0,1000)")
        #sleep and let the scroll bar react
        time.sleep(5)
        #Get the distance of the current scroll bar from the top
        check_height = driver.execute_script("return document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;")
        #If the two are equal to the end
        if check_height==temp_height:
            break
        temp_height=check_height
        
    time.sleep(10)
    
    soup = BeautifulSoup(driver.page_source,'html.parser')
    
    product_cards = soup.find_all('li','product-item')
    
    for everyProduct in product_cards: # for loops to add every products detail into object named records
        productDetails = get_all_products(everyProduct)
        records.append(productDetails)
        
    col = ['Product_Image','Product_Name','Product_Price','Product_Link'] # column name
    
    prestomall_data = pd.DataFrame(records,columns=col)
    prestomall_data.to_csv('D:\\PrestomallData.csv') # convert into dataframe and save on computer
    


# In[3]:


product = input('Enter the product you are looking for : ') # enter the product we are looking for
main(product)


# In[ ]:




