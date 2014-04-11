#!/usr/bin/env ruby

# Script to generate PDF cards suitable for planning poker
# from Pivotal Tracker [http://www.pivotaltracker.com/] CSV export.

# Inspired by Bryan Helmkamp's http://github.com/brynary/features2cards/

# Example output: http://img.skitch.com/20100522-d1kkhfu6yub7gpye97ikfuubi2.png

require 'rubygems'
require 'csv'
require 'ostruct'
require 'term/ansicolor'
require 'prawn'
require 'prawn/layout/grid'
#require "rqr"


$: << File.join(File.dirname(__FILE__), 'lib')
require 'card'

class String; include Term::ANSIColor; end

file = ARGV.first

unless file
  puts "[!] Please provide a path to CSV file"
  exit 1
end

cards = Card.read_from_csv(file)

begin

outfile = File.basename(file, ".csv")

Prawn::Document.generate("#{outfile}.pdf",
   :page_layout => :portrait,
   :margin      => [25, 25, 25, 25],
   :page_size   => 'A4') do |pdf|

    @num_cards_on_page = 1

    #pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"

    cards.each_with_index do |card, i|
      pdf.start_new_page
      pdf.define_grid(:columns => 1, :rows => 1, :gutter => 10)
      card.generate_pdf(pdf, pdf.grid( 0, 0 ))
    end

    # --- Footer
    #pdf.number_pages "#{outfile}.pdf", [pdf.bounds.left,  -28]
    #pdf.number_pages "<page>/<total>", [pdf.bounds.right-16, -28]
end

puts ">>> Generated PDF file in '#{outfile}.pdf' with #{cards.size} stories:".black.on_green

cards.each do |card|
  puts "* #{card.title}"
end

rescue Exception
  puts "[!] There was an error while generating the PDF file... What happened was:".white.on_red
  raise
end
