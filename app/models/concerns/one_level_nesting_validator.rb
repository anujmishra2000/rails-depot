class OneLevelNestingValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, "can have only one level of nesting" if record.parent.parent_id?
  end
end
