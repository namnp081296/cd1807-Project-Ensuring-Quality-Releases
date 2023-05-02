# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
import warnings
import logging

# Turn off all warning output
warnings.filterwarnings("ignore", category=DeprecationWarning) 

# Setup output INFO log format
logging.basicConfig(
    format='%(asctime)s %(levelname)-8s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S')

options = ChromeOptions()

# Will run selenium with non GUI, just output the result log
options.add_argument("--no-sandbox")
options.add_argument("--headless") 
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--disable-gpu") 
options.add_argument("--disable-extensions")
# options.add_argument('--remote-debugging-port=9999')
driver = webdriver.Chrome(options=options)

# 
logging.info('Browser started successfully. Navigating to the demo page to login.')
driver.get('https://www.saucedemo.com/')

# Login with username "standard_user"
def login (user, password):
    logging.info('Starting the browser...')
    driver.find_element(By.CSS_SELECTOR, "input[id='user-name']").send_keys(user)
    driver.find_element(By.CSS_SELECTOR, "input[id='password']").send_keys(password)
    driver.find_element(By.CSS_SELECTOR, "input[id='login-button']").click()   
    logging.info('Logged in with username ' + user + ' succesfully')

# Add all item to cart
def add_all():
    logging.info('Starting add all 6 items to cart')
    # Get all element with attribute btn_inventory
    items = driver.find_elements(By.CSS_SELECTOR, "button.btn_primary.btn_inventory")

    # Click Add button
    for item in items:
        # Get name of product
        product = item.get_property("name")
        logging.info('- ' + product + ' has been added to the cart')
        item.click()

    # Set The number of items visible in badge icon
    cart_label = driver.find_element(By.CSS_SELECTOR, '.shopping_cart_badge').text
    assert cart_label == '6'

# Remove all items in cart
def remove_all():
    driver.find_element(By.CSS_SELECTOR, "a[class='shopping_cart_link']").click()
    logging.info('Starting remove all items in cart')
    items = driver.find_elements(By.CSS_SELECTOR, "button.cart_button")

    for item in items:
        product = item.get_property("name")
        logging.info('- ' + product +' has been removed out of the cart')
        item.click()

login('standard_user', 'secret_sauce')
add_all()
remove_all()