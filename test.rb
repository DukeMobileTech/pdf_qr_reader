require 'grim'
require 'zxing'
require 'rmagick'
require 'csv'
require 'rtesseract'

Dir.glob('scans/*.pdf') do |pdf_file|
  pdf_pages = Grim.reap(pdf_file) # Break pdf into pages
  pdf_pages.each do |page|
    filename = "images/#{pdf_file.split('/').last.split('.').first}-#{page.number}.png"
    page.save(filename) # Save pdf as image
    img = Magick::Image.read(filename).first # Read image into rmagick
    image = img.crop(160, 395, 350, 40)
    image.write("#{filename}-crop.png")
    rimage = RTesseract.new("#{filename}-crop.png", :lang => "eng", options: :digits)
    puts rimage.to_s
  end
end
