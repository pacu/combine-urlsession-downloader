
Pod::Spec.new do |s|
  s.name             = 'CombineUrlSessionDownloader'
  s.version          = '1.0.0'
  s.summary          = 'an URLSession Extension to download stuff using Combine'

  s.description      = <<-DESC
Downloading a resource from an URL seems like a trivial task, but is it really that easy? Well, it depends. If you have to download and parse a JSON file which is just a few KB, then you can go with the classical way or you can use the new dataTaskPublisher method on the URLSession object from the Combine framework, for bigger downloads, it's best to use download tasks which are not currently available as publishers on URLSession or at least yet. This pod is based on
                       DESC

  s.homepage         = 'https://github.com/pacu/combine-urlsession-downloader'
  s.module_name      = 'combine_urlsession_downloader'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Francisco Gindre' => 'francisco.gindre@gmail.com' }
  s.source           = { :git => 'https://github.com/pacu/combine-urlsession-downloader.git', :tag => s.version.to_s }


  s.ios.deployment_target = '13.0'
  s.swift_version = '5.4'
  s.source_files = 'Sources/**/*.{swift}'

  s.test_spec 'combine-url-session-downloader-tests' do | test_spec |
      test_spec.source_files = 'Tests/**/*.{swift}'
  end

  s.frameworks = 'Combine'
end
