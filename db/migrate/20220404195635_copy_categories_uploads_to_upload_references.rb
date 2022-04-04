# frozen_string_literal: true

class CopyCategoriesUploadsToUploadReferences < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      INSERT INTO upload_references(upload_id, target_type, target_id, created_at, updated_at)
      SELECT uploaded_logo_id, 'Category', id, created_at, updated_at
      FROM categories
      WHERE uploaded_logo_id IS NOT NULL
    SQL

    execute <<~SQL
      INSERT INTO upload_references(upload_id, target_type, target_id, created_at, updated_at)
      SELECT uploaded_background_id, 'Category', id, created_at, updated_at
      FROM categories
      WHERE uploaded_background_id IS NOT NULL
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
