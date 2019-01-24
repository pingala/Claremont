
"""
This file contains Python code matching the R code in
the slides of Workshop 2: Crawling and Scraping
"""


############################################
# Crawling Multiple Static Websites
############################################

import requests
for year in range(2015, 2019):
    link = "https://www.basketball-reference.com/teams/NYK/%s.html" % (year)
    filename = "bbref_NYK_%s.html" % (year)
    
    with open(filename, "w") as fout:
        fout.write(requests.get(link).text)


############################################
# Crawling Dynamic Webpages
#
# Note: Requires download of chromedriver
############################################

from selenium import webdriver
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
# chrome_options.add_argument('--headless') # Neagtes GUI presence
browser = webdriver.Chrome("./chromedriver", chrome_options=chrome_options)
browser.get("https://inmatesearch.charlestoncounty.org/")


# Focus on date box
browser.find_element_by_css_selector("#ctl00_MainContent_txtBookDtFrom").click()

# Fill in the date
browser.find_element_by_css_selector("#ctl00_MainContent_txtBookDtFrom").send_keys("1/1/2018")

# Click search
browser.find_element_by_css_selector("#MainContent_btnSearch").click()

# Click number of records drop down
browser.find_element_by_css_selector("#MainContent_ddnRcrdsPerPage").click()

# select 100 so we minimize interaction (and code written)
browser.find_element_by_css_selector("#MainContent_ddnRcrdsPerPage > option:nth-child(4)").click()

# This will grab the number of page links at the bottom of the page
num_pages = len(browser.find_element_by_css_selector("#MainContent_dpListView").find_elements_by_css_selector("*"))


####################################################
# Python and R have different tools for scraping
# Checkout BeautifulSoup for methodlogies in Python
####################################################



