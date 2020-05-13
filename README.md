# JupyterOnRails

Integrate Rails and Jupyter

![Alt text](the_screenshot.png?raw=true "Title")

## Motivation

Although it was already possible to run `jupyter` + `iruby` and `require app_full_path` to load Rails application context,
it is a bit tiring to each time copy all the `require` statements.

Moreover, since Rails Way works in keeping (generally) everything under the project directory,
managing the jupyter configuration installed in user global area (the iruby kernel register thing) is again a bit awkward.

With this gem, these awkwardness is to solved by following instruments:
  * `rake jupyter:notebook` Railtie command which invokes jupyter at your project root, and
  * This rake task automatically creates two `iruby` kernels to load your application in Jupyter:
    * one for normal operation
    * one for sandbox mode in which everything you do is wrapped in a database transaction that is rolled back when the
      kernel exits (equivalent to `rails console --sandbox`)


## Prerequisites

* iruby's prerequisites must be met.
  * Refer: https://github.com/SciRuby/iruby
    * Either `cztop` or `ffi-rzmq` gem must be installable.

* `jupyter` command must be somehow available.
  * Either
    * `jupyter` command (pip global install, anaconda, etc), or
    * `pipenv run jupyter` command (managed by Pipfile at project root)

## Installation

Add these lines to your application's Gemfile:

```ruby
gem 'jupyter_on_rails'

# For sessions pick either:
gem 'ffi-rzmq'
# Or
gem 'cztop'
```

And then execute:

    $ bundle install

## Usage

Starting the jupyter server is available as a rake command.

Just execute:

```sh
rake jupyter:notebook
```

Eventually, you'll have jupyter opened, and the kernel being available.


### ApplicationRecord.to_df/#to_df

```ruby
User.to_df # => Daru::DataFrame is returned
user.to_df # => Daru::DataFrame for single record
```

### Daru::DataFrame#write_model

For each row, call `to_h` and pass it to `model.new`.
And then, imports them using `model.insert_all` on Rails >= 6, or `model.import` (requires adding
`activerecord-import` to your `Gemfile`).

```ruby
df.write_model(User)
```

## Development

This is a railtie gem, so you'd probably want to do something like:

```
gem 'jupyter_on_rails', git: 'GIT_URL_OF_YOUR_REPO',
                        branch: 'the-work-branch'
```

or

```
gem `jupyter_on_rails`, path: 'jupyter_on_rails_as_sub_project'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Yuki-Inoue/jupyter_on_rails.
