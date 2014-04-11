class Card < OpenStruct
  def type
    @table[:type]
  end

  def generate_pdf(pdf, cell)
    padding = 12

    cell.bounding_box do

      pdf.stroke_color = "666666"
      pdf.stroke_bounds

      pdf.text_box self.title, :at => [pdf.bounds.left+padding, pdf.bounds.top-padding],
                               :width => (cell.width-padding*2), :height => 20, :size => 12,
                               :overflow => :shrink_to_fit, :min_font_size => 10, :style => :bold

      pdf.text_box "#{self.type.capitalize} #{self.story_id}",  :size => 8, :align => :right, :at => [12, pdf.bounds.top-padding], :width => cell.width-18
      pdf.text_box self.label,  :at => [pdf.bounds.left+padding, pdf.bounds.top-padding-18],  :width => (cell.width-padding*2), :height => 14, :size => 9, :style => :italic
      pdf.text_box "Points: " + self.points, :size => 10, :align => :right, :at => [12, pdf.bounds.top-padding-24], :width => cell.width-18

      pdf.text_box 'Description', :size => 11,  :at => [pdf.bounds.left+padding, pdf.bounds.top-padding-44], :width => (cell.width-padding*2), :height => 20, :style => :bold
      pdf.text_box self.body, :size => 9, :at => [pdf.bounds.left+padding, pdf.bounds.top-padding-74], :width => (cell.width-padding*2), :height => auto

      pdf.text_box 'Activité', :size => 11,  :at => [pdf.bounds.left+padding, pdf.bounds.top-padding-334], :width => (cell.width-padding*2), :height => 20, :style => :bold
      pdf.move_down 364
      comments = [[comment_1], [comment_2], [comment_3], [comment_4], [comment_5], [comment_6], [comment_7]]

      pdf.table(comments, :row_colors => ["F0F0F0", "FFFFFF"], :width => cell.width, :cell_style => {:size => 9})

    end
  end

  def qrcode_filename
    File.join(File.dirname(__FILE__), "qrcode_#{self.story_id}.png")
  end

  def self.read_from_csv(csv_file)
    stories = CSV.read(csv_file)
    headers = stories.shift

    stories.map do |story|
      attrs =  {
                 :story_id     => story[0]   || '',
                 :title  => story[1]   || '',
                 :body   => story[13]  || '',
                 :label   => story[2]  || '',
                 :type   => story[6]   || '',
                 :points => story[7]   || '...',
                 :owner  => story[15]  || '.'*50,
                 :url    => story[14] ,
                 :comment_1   => story[16] || '',
                 :comment_2   => story[17] || '',
                 :comment_3   => story[18] || '',
                 :comment_4   => story[19] || '',
                 :comment_5   => story[20] || '',
                 :comment_6   => story[21] || '',
                 :comment_7   => story[22] || '',
                 :task_1          => story[23] || '',
                 :task_2          => story[25] || '',
                 :task_3          => story[27] || '',
                 :task_4          => story[29] || '',
                 :task_5          => story[31] || ''
               }

      Card.new attrs
    end
  end

end
