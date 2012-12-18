# encoding: utf-8
#
require 'csv'
require 'pdf/writer'
class Label < Struct.new(:name, :street, :zip, :city, :state, :country, :package)
  def package
    super[0]
  end

  def label_lines
    lines = []
    lines << name
    lines << street
    puts city
    if state && !state.empty? && state != "--- Select ---"
      lines << city
      lines << "#{zip} #{state}"
    else
      lines << "#{zip} #{city}"
    end
    if country.nil?
      puts "#{name} was without country: #{zip} #{city} #{state}"
      self.country = "USA"
    end
    lines << country
    lines
  end
end

labels = []
CSV.foreach('by_donation_and_date.csv', :col_sep => ';') do |row|
  labels << Label.new(*row)
end

module PdfLabelMaker
  include PDF

  def self.cell_x(col, options)
    options[:left_margin] + (col * options[:label_width]) + (col * options[:gap_between_labels_x]) + options[:label_padding_x]
  end

  def self.cell_y(row, options)
    options[:bottom_margin] + (((options[:labels_per_page] / options[:columns]) - row) * options[:label_height]) - options[:label_padding_y]
  end

  def self.add_label(row, col, contact, pdf, options)
    if contact
      pdf.fill_color(Color::RGB::Black)
      label_text_width = options[:label_width]
      pdf.add_text_wrap(cell_x(col, options), cell_y(row, options) + 70, label_text_width + 20, "Travis CI, Prinzessinnenstr. 20, 10969 Berlin, Germany", 9)
      contact.label_lines.each_with_index do |line, idx|
        if line.nil?
          puts "Line was nil for #{contact}"
        end
        label_text_width = options[:label_width] - (2 * options[:label_padding_x])
        pdf.add_text_wrap(cell_x(col, options), cell_y(row, options) - (idx * options[:line_height]), label_text_width, line, options[:font_size])
      end
      label_text_width = options[:label_width]
      pdf.fill_color(Color::RGB::Gray40)
      pdf.add_text_wrap(cell_x(col, options) + label_text_width - 25, cell_y(row, options) + 70, label_text_width + 20, contact.package, 8)
    end
  end

  def self.avery_labels(contacts, code='L7162', options={})
    options[:paper_size] ||= 'A4'
    options[:font] ||= 'Helvetica'

    set_layout_options(code, options)

    pdf = PDF::Writer.new(:paper => options[:paper_size])
    pdf.select_font(options[:font], :encoding => nil)

    pages = contacts.length / options[:labels_per_page]
    pages += 1 if (contacts.length % options[:labels_per_page]) > 0

    0.upto(pages - 1) do |page|
      start = page * options[:labels_per_page]
      addresses_for_page = contacts[start..(start + options[:labels_per_page])]

      0.upto((options[:labels_per_page] / options[:columns]) - 1) do |row|
        0.upto(options[:columns] - 1) do |column|
          add_label(row, column, addresses_for_page[(row * options[:columns]) + column], pdf, options)
        end
      end

      pdf.new_page unless page + 1 == pages
    end
    pdf
  end

  def self.set_layout_options(code, options)
    case code
    when 'L7162' then
      options[:columns] ||= 2
      options[:labels_per_page] ||= 16
      options[:left_margin] ||= Writer.mm2pts 0
      options[:bottom_margin] ||= Writer.mm2pts 12
      options[:label_width] ||= Writer.mm2pts 99.1
      options[:label_height] ||= Writer.mm2pts 33.9
      options[:label_padding_x] ||= Writer.mm2pts 0
      options[:label_padding_y] ||= Writer.mm2pts 3
      options[:gap_between_labels_x] ||= Writer.mm2pts 0
      options[:font_size] ||= 10
      options[:line_height] ||= 11
    when 'J8651' then
      options[:columns] ||= 5
      options[:labels_per_page] ||= 65
      options[:left_margin] ||= Writer.mm2pts 4
      options[:bottom_margin] ||= Writer.mm2pts 10
      options[:label_width] ||= Writer.mm2pts 38.1
      options[:label_height] ||= Writer.mm2pts 21.2
      options[:label_padding_x] ||= Writer.mm2pts 1
      options[:label_padding_y] ||= Writer.mm2pts 1
      options[:gap_between_labels_x] ||= Writer.mm2pts 3
      options[:font_size] ||= 6
      options[:line_height] ||= 7
    when 'Zweckform4737' then
      options[:columns] ||= 3
      options[:labels_per_page] ||= 27
      options[:left_margin] ||= Writer.mm2pts 7.2
      options[:bottom_margin] ||= Writer.mm2pts 15.1
      options[:label_width] ||= Writer.mm2pts 63.5
      options[:label_height] ||= Writer.mm2pts 29.6
      options[:label_padding_x] ||= Writer.mm2pts 10
      options[:label_padding_y] ||= Writer.mm2pts 4.5
      options[:gap_between_labels_x] ||= Writer.mm2pts 2.5
      options[:font_size] ||= 9
      options[:line_height] ||= 10
    end
  end
end

require 'iconv'

CONVERTER = Iconv.new('ISO-8859-15//IGNORE//TRANSLIT', 'utf-8')

# module PDF
#   class Writer
#     alias_method :old_add_text_wrap, :add_text_wrap
#
#     def add_text_wrap(x, y, width, text, size = nil, justification = :left, angle = 0, test = false)
#       old_add_text_wrap(x, y, width, CONVERTER.iconv(text), size, justification, angle, test)
#     end
#   end
# end
#
class String
  def to_iso
    puts 'to_iso'
    c = Iconv.new('ISO-8859-15','UTF-8')
    c.iconv(self)
  end
end

options = Hash.new.tap do |options|
  options[:columns] ||= 2
  options[:labels_per_page] ||= 8
  options[:left_margin] ||= PDF::Writer.mm2pts 0
  options[:bottom_margin] ||= PDF::Writer.mm2pts 8
  options[:label_width] ||= PDF::Writer.mm2pts 99.1
  options[:label_height] ||= PDF::Writer.mm2pts 67.7
  options[:label_padding_x] ||= PDF::Writer.mm2pts 10
  options[:label_padding_y] ||= PDF::Writer.mm2pts 25
  options[:gap_between_labels_x] ||= PDF::Writer.mm2pts 0
  options[:font_size] ||= 14
  options[:line_height] ||= 18
end
#labels << Label.new
#8.times { labels << Label.new}
pdf = PdfLabelMaker.avery_labels(labels, '4781', options)
File.open("labels.pdf", "w") {|f| f.write(pdf)}
