# frozen_string_literal: true

class UploadReference < ActiveRecord::Base
  belongs_to :upload
  belongs_to :target, polymorphic: true
end

# == Schema Information
#
# Table name: upload_references
#
#  id          :bigint           not null, primary key
#  upload_id   :bigint           not null
#  target_type :string           not null
#  target_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_upload_references_on_target             (target_type,target_id)
#  index_upload_references_on_upload_and_target  (upload_id,target_type,target_id) UNIQUE
#  index_upload_references_on_upload_id          (upload_id)
#
