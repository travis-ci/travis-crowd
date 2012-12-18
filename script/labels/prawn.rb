# encoding: utf-8
#
require 'csv'
require 'prawn'
include Prawn::Measurements

# ["529", "Tiny", "Michael Stillwell", "mjs@beebo.org", "159B Essex Rd", "N1 2SN", "London", nil, "United Kingdom"]"
class Label < Struct.new(:package, :name, :email, :street, :zip, :city, :state, :country)
  def package
    super[0]
  end

  def label_lines
    lines = []
    lines << name
    lines << street
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
CSV.foreach(ARGV[0], headers: true, force_quotes: false, col_sep: ',') do |row|
  row = row.values_at(*%w(package address_name email address_street address_zip address_city address_state address_country))
  labels << Label.new(*row)
end

module PdfLabelMaker
  def self.cell_x(col, options)
    options[:left_margin] + (col * options[:label_width]) + (col * options[:gap_between_labels_x]) + options[:label_padding_x]
  end

  def self.cell_y(row, options)
    options[:bottom_margin] + (((options[:labels_per_page] / options[:columns]) - row) * options[:label_height]) - options[:label_padding_y]
  end

  def self.add_label(row, col, contact, pdf, options)
    if contact
      pdf.fill_color("000000")
      label_text_width = options[:label_width]
      pdf.font_size(9)
      pdf.text_box("Travis CI, Prinzessinnenstr. 20, 10969 Berlin, Germany", :at =>  [cell_x(col, options), cell_y(row, options) + 70], :width => label_text_width + 20)
      pdf.font_size(14)
      contact.label_lines.each_with_index do |line, idx|
        if line.nil?
          puts "Line was nil for #{contact}"
        end
        label_text_width = options[:label_width] - (options[:label_padding_x])
        pdf.text_box(line, :at => [cell_x(col, options), cell_y(row, options) - (idx * options[:line_height])], :height => 20, :width => label_text_width, :overflow => :shrink_to_fit)
      end
      label_text_width = options[:label_width]
      pdf.font_size(9)
      pdf.fill_color("696969")
      pdf.text_box(contact.package, :at => [cell_x(col, options) + label_text_width - 30, cell_y(row, options) + 70], :width => label_text_width + 20)
    end
  end

  def self.avery_labels(contacts, code='L7162', options={})
    options[:paper_size] ||= 'A4'
    options[:font] ||= 'Helvetica'

    set_layout_options(code, options)

    pdf = Prawn::Document.new(:page_size => options[:paper_size], :margin => 0)
    pdf.font(options[:font])

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

      pdf.text_box(page.to_s, :at => [20, 20], :width => 20)
      pdf.start_new_page unless page + 1 == pages
    end
    pdf.render_file "labels.pdf"
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

options = Hash.new.tap do |options|
  options[:columns] ||= 2
  options[:labels_per_page] ||= 8
  options[:left_margin] ||= mm2pt 0
  options[:bottom_margin] ||= mm2pt 8
  options[:label_width] ||= mm2pt 99.1
  options[:label_height] ||= mm2pt 67.7
  puts options[:label_width]
  options[:label_padding_x] ||= mm2pt 12
  options[:label_padding_y] ||= mm2pt 25
  options[:gap_between_labels_x] ||= mm2pt 0
  options[:font_size] ||= 14
  options[:line_height] ||= 18
end

#labels << Label.new
#8.times { labels << Label.new}
PdfLabelMaker.avery_labels(labels, '4781', options)
`mv labels.pdf #{ARGV[1]}` if ARGV[1]
