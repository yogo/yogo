# shared_examples_for 'CSV File Loading Support' do
#   #
#   # At the project level cvs upload means creating a model and instances from a spreadsheet
#   # There are a set of tests that should be done on the model creation piece, but
#   # the instance creation tests overlap significantly with the yogo_models_controller csv handling.
#   # 
#   describe 'csv file handling' do
#     describe 'data validation' do
#       it 'should validate types are valid in the spreadsheet'
#       it 'should return an error when bad types are used in the spreadsheet'
#     end
# 
#     describe 'data creation' do
#       it 'should create instances of the model from all valid rows of the spreadsheet'
#       it 'should warn about invalid instance/row data but continue to create subsequent instances'
#     end # csv handling
#   end
# end