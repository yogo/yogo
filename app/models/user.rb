class User
  include Yogo::YogoUser
  include Yogo::Pagination

  # A useful method
  def puts_moo
    puts 'moo'
  end
end
