# frozen_string_literal: true

class CopySiteSettingsUploadsToUploadReferences < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      INSERT INTO upload_references(upload_id, target_type, target_id, created_at, updated_at)
      SELECT value::integer, 'SiteSetting', id, created_at, updated_at
      FROM site_settings
      WHERE data_type = 18
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
