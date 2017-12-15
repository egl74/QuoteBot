require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'telegram/bot'

class Quote
  def getQuotesByUri(uri)
    doc = Nokogiri::HTML.parse(open(uri))
    quotes = doc.css('p').drop(4).map { |quote| quote.text }
  end
end

aglUri = "https://ru.wikiquote.org/wiki/%D0%90%D0%BB%D0%B5%D0%BA%D1%81%D0%B0%D0%BD%D0%B4%D1%80_%D0%93%D1%80%D0%B8%D0%B3%D0%BE%D1%80%D1%8C%D0%B5%D0%B2%D0%B8%D1%87_%D0%9B%D1%83%D0%BA%D0%B0%D1%88%D0%B5%D0%BD%D0%BA%D0%BE#%D0%A6%D0%B8%D1%82%D0%B0%D1%82%D1%8B"
aglQuotes = Quote.new.getQuotesByUri(aglUri)

Telegram::Bot::Client.run(ENV["TOKEN"]) do |bot|
  bot.listen do |message|
    case message.text
      when '/agl'
        bot.api.send_message(chat_id: message.chat.id, text: aglQuotes.sample)
    end
  end
end
