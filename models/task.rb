class Task < Ohm::Model
  attribute :title
  attribute :done
  reference :on_list, :TaskList
  index :done

  def validate
    assert_present :title
    assert_present :on_list
  end

end
