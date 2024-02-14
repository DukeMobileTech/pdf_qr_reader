require 'grim'
require 'zxing'
require 'rmagick'
require 'csv'
require 'rtesseract'

CSV.open('decoded_qr_codes.csv', 'wb') do |csv|
  csv << ['page', 'id']
  Dir.glob('scans/*.pdf') do |pdf_file|
    pdf_pages = Grim.reap(pdf_file) # Break pdf into pages
    pdf_pages.each do |page|
      filename = "images/#{pdf_file.split('/').last.split('.').first}-#{page.number}.png"
      page.save(filename) # Save pdf as image
      decoded_string = ZXing.decode(filename) # Decode QR Code in page
      if decoded_string.nil? || decoded_string.empty?
        img = Magick::Image.read(filename).first # Read image into rmagick
        image = img.crop(160, 75, 120, 105) # Extract QR Code part of the image
        image.write("#{filename}-crop.png") # Save QR Code as image
        decoded_string = ZXing.decode("#{filename}-crop.png") # Decode QR Code in page
        decoded_string = 'Not Found' if decoded_string.nil? || decoded_string.empty?
        # File.delete("#{filename}-crop.png")
      end
      csv << ["#{pdf_file.split('/').last.split('.').first}-#{page.number}", decoded_string]
      # File.delete(filename)
      rimage = RTesseract.new(filename)
      puts rimage.to_s
    end
  end
end
