Sequel.migration do
  change do
    alter_table(:users) do
      add_column :administrator, TrueClass, :default => false
    end
  end
end