# This file (stages.rb) is used to define the stages within your production.
#
# Below is an example statge configuration.
#
#  stage "center_stage" do
#    default_scene "main"
#    title "Limelight Center Stage"
#    location [0, 0]
#    size [300, 800]
#  end

stage "default" do
  default_scene "board"
  title "Tic Tac Toe"
  location [200, 25]
  size [310, 562]
end