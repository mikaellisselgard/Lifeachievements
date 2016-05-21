class AddRecordImageToSearchResult < ActiveRecord::Migration
  def change
    add_column :search_results, :record_image, :string
  end
end
