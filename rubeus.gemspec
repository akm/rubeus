Gem::Specification.new do |spec|
  spec.name = "rubeus"
  spec.version = "0.0.2"
  spec.platform = "java"
  spec.summary = "Rubeus provides you an easy access to Java objects from Ruby scripts on JRuby"
  spec.author = "Takeshi Akima"
  spec.email = "rubeus@googlegroups.com"
  spec.homepage = "http://code.google.com/p/rubeus/"
  candidates = Dir.glob("{lib, examples}/**/*")
  spec.files = candidates.delete_if do |item|
    (/\..*~$/ =~ item) || item.include?(".svn") || item.include?("rdoc")
  end
  spec.require_path = "lib"
  spec.has_rdoc = false
  spec.rubyforge_project = "rubybizcommons"
  spec.add_dependency("activesupport", ">= 2.0.2")
end
