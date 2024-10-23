WickedPdf.configure do |config|
  config.wkhtmltopdf = Gem.bin_path("wkhtmltopdf-binary", "wkhtmltopdf")
end
