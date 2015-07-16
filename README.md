# PaperclipStorageFilesystemVersioned

Next storage for paperclip. Based on Filesystem but offering files versioning support.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paperclip_storage_filesystem_versioned'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip_storage_filesystem_versioned

## Usage

Basic example (with paper_trial enabled):

```ruby
class User < ActiveRecord::Base
  has_attached_file :some_nice_document_or_whatever,
    :storage => :filesystem_versioned
end
```

Little more complicated example (can define `Proc` for version number determine):

```ruby
class User < ActiveRecord::Base
  has_attached_file :some_nice_document_or_whatever,
    :storage => :filesystem_versioned,
    :version_proc => Proc.new { |attachment, style| attachment.instance.versions.count}
end
```

## Contributing

1. Fork it ( https://github.com/stricte/paperclip_storage_filesystem_versioned/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

[MIT License](LICENSE)
