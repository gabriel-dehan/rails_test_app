class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.string :path
      t.string :type

      t.timestamps
    end
  end
end
