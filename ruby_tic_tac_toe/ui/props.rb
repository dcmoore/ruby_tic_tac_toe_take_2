__ :name => "board"
squares {
  [0, 1, 2, 3, 4, 5, 6, 7, 8].each do |s|
    square :id => "square"+s.to_s, :text => s
  end
}