# Meta checker

Check your meta!

## Description

1. `git clone git@github.com:netology-group/meta_checker.git && cd meta_checker`
2. Edit `spec/requests/main_spec.rb`:

- configure `path_to_sitemap` (url or local file - see examples)
- set array of required metatags with name attribute - `required_meta_names`
- set array of required metatags with property attribute - `require_meta_properties`

3. Run main spec:

```bash
$ bundle
$ rspec
```
4. Optionally you can comment out useless it blocks
5. To collect specs data run command:

```bash
$ rspec > specs_output
```
