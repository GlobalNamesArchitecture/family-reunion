# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{family-reunion}
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dmitry Mozzherin", "David Shorthouse"]
  s.date = %q{2011-06-23}
  s.description = %q{An algorithm to merge related nodes of two taxonomic hierarchies with synonym information}
  s.email = %q{dmozzherin@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "family-reunion.gemspec",
    "features/family-reunion.feature",
    "features/step_definitions/family-reunion_steps.rb",
    "features/support/env.rb",
    "lib/family-reunion.rb",
    "lib/family-reunion/cache.rb",
    "lib/family-reunion/exact_matcher.rb",
    "lib/family-reunion/fuzzy_matcher.rb",
    "lib/family-reunion/matcher_helper.rb",
    "lib/family-reunion/nomatch_organizer.rb",
    "lib/family-reunion/taxamatch_preprocessor.rb",
    "lib/family-reunion/taxamatch_wrapper.rb",
    "lib/family-reunion/top_node.rb",
    "scripts/dwca2fr.rb",
    "spec/family-reunion_spec.rb",
    "spec/fixtures/ants_primary.json",
    "spec/fixtures/ants_secondary.json",
    "spec/fixtures/matched_merges.json",
    "spec/fixtures/nodes_to_match.json",
    "spec/fixtures/synonyms_strings_primary.json",
    "spec/fixtures/synonyms_strings_secondary.json",
    "spec/fixtures/valid_names_strings_primary.json",
    "spec/fixtures/valid_names_strings_secondary.json",
    "spec/fuzzy_matcher_spec.rb",
    "spec/nomatch_organizer_spec.rb",
    "spec/spec_helper.rb",
    "spec/taxamatch_preprocessor_spec.rb",
    "spec/taxamatch_wrapper_spec.rb",
    "spec/top_node_spec.rb"
  ]
  s.homepage = %q{http://github.com/GlobalNamesArchitecture/family-reunion}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An algorithm to merge related nodes of two taxonomic hierarchies}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dwc-archive>, [">= 0.5.13"])
      s.add_runtime_dependency(%q<taxamatch_rb>, ["~> 0.7.6"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_development_dependency(%q<ruby-prof>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<dwc-archive>, [">= 0.5.13"])
      s.add_dependency(%q<taxamatch_rb>, ["~> 0.7.6"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_dependency(%q<ruby-prof>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<dwc-archive>, [">= 0.5.13"])
    s.add_dependency(%q<taxamatch_rb>, ["~> 0.7.6"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
    s.add_dependency(%q<ruby-prof>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end

