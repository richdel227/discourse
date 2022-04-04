# frozen_string_literal: true

describe UploadReference do
  context 'badge uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      badge = nil
      expect { badge = Fabricate(:badge, image_upload_id: upload.id) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(badge)

      expect { badge.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'category uploads' do
    fab!(:upload1) { Fabricate(:upload) }
    fab!(:upload2) { Fabricate(:upload) }

    it 'creates upload references' do
      category = nil
      expect { category = Fabricate(:category, uploaded_logo_id: upload1.id, uploaded_background_id: upload2.id) }
        .to change { UploadReference.count }.by(2)

      upload_reference = UploadReference.last
      expect(upload_reference.target).to eq(category)

      expect { category.destroy! }
        .to change { UploadReference.count }.by(-2)
    end
  end

  context 'custom emoji uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      custom_emoji = nil
      expect { custom_emoji = CustomEmoji.create!(name: 'emoji', upload_id: upload.id) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.target).to eq(custom_emoji)

      expect { custom_emoji.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'group uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      group = nil
      expect { group = Fabricate(:group, flair_upload_id: upload.id) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(group)

      expect { group.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'post uploads' do
    fab!(:upload) { Fabricate(:upload) }
    fab!(:post) { Fabricate(:post, raw: "[](#{upload.short_url})") }

    it 'creates upload references' do
      expect { post.link_post_uploads }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(post)

      expect { post.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'site setting uploads' do
    let(:provider) { SiteSettings::DbProvider.new(SiteSetting) }
    fab!(:upload) { Fabricate(:upload) }
    fab!(:upload2) { Fabricate(:upload) }

    it 'creates upload references for uploads' do
      expect { provider.save('logo', upload.id, SiteSettings::TypeSupervisor.types[:upload]) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(SiteSetting.find_by(name: 'logo'))

      expect { provider.destroy('logo') }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'theme field uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload refererences' do
      theme_field = nil
      expect do
        theme_field = ThemeField.create!(
          theme_id: Fabricate(:theme).id,
          target_id: 0,
          name: 'field',
          value: '',
          upload: upload,
          type_id: ThemeField.types[:theme_upload_var],
        )
      end.to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(theme_field)

      expect { theme_field.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'user export uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      user_export = nil
      expect do
        user_export = UserExport.create!(
          file_name: 'export',
          user: Fabricate(:user),
          upload: upload,
          topic: Fabricate(:topic),
        )
      end.to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(user_export)

      expect { user_export.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'theme field uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload refererences' do
      theme_field = nil
      expect do
        theme_field = ThemeField.create!(
          theme_id: Fabricate(:theme).id,
          target_id: 0,
          name: 'field',
          value: '',
          upload: upload,
          type_id: ThemeField.types[:theme_upload_var],
        )
      end.to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(theme_field)

      expect { theme_field.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'theme setting uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload refererences' do
      theme_setting = nil
      expect do
        theme_setting = ThemeSetting.create!(
          name: 'field',
          data_type: ThemeSetting.types[:upload],
          value: upload.id,
          theme_id: Fabricate(:theme).id,
        )
      end.to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(theme_setting)

      expect { theme_setting.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end

  context 'user uploads' do
    fab!(:upload) { Fabricate(:upload) }

    it 'creates upload references' do
      user = nil
      expect { user = Fabricate(:user, uploaded_avatar_id: upload.id) }
        .to change { UploadReference.count }.by(1)

      upload_reference = UploadReference.last
      expect(upload_reference.upload).to eq(upload)
      expect(upload_reference.target).to eq(user)

      expect { user.destroy! }
        .to change { UploadReference.count }.by(-1)
    end
  end
end
