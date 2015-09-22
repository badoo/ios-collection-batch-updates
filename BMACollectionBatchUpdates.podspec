Pod::Spec.new do |s|

  s.name         = "BMACollectionBatchUpdates"
  s.version      = "1.0.0"
  s.summary      = ""
  s.description  = <<-DESC
                   BMACollectionBatchUpdates` is a set of classes and extensions to UICollectionView and UITableView to perform safe batch updates of these views.
                   DESC
  s.homepage     = "http://github.com/badoo/BMACollectionBatchUpdates"
  s.license      = { :type => "MIT"}
  s.author       = { "Vladimir Magaziy" => "vladimir.magaziy@corp.badoo.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/badoo/BMACollectionBatchUpdates.git", :tag => s.version.to_s }
  s.source_files = "BMACollectionBatchUpdates/*"
  s.public_header_files = "BMACollectionBatchUpdates/*.h"
  s.requires_arc = true

end
