import scrapy


class DavidgunSpider(scrapy.Spider):
    name = "davidgun"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io/"]

    def parse(self, response):
        pass
