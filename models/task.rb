class Task < Ohm::Model
  attribute :title
  attribute :done

  def validate
    assert_present :title
  end
end
