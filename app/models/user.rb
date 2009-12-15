class User
  include YogoAuthz::YogoUser

  # A useful method
  def puts_moo
    puts 'moo'
  end
end
