class Task < Ohm::Model
  attribute :title
  attribute :done
  index :done

  def validate
    assert_present :title
  end

  def self.to_complete
    Task.find(done: false)
  end
end
