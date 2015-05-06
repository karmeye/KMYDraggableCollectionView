Pod::Spec.new do |spec|
  spec.name         = "KMYDraggableCollectionView"
  spec.version      = "0.2"
  spec.summary      = "Extension for the UICollectionView and UICollectionViewLayout that allows a user to move items with drag and drop."
  spec.homepage     = "https://github.com/karmeye/KMYDraggableCollectionView"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.authors      = [ 'Luke Scott', 'Karmeye' ]
  spec.source       = { :git => "https://github.com/karmeye/KMYDraggableCollectionView.git", :tag => spec.version.to_s }
  spec.platform     = :ios, '7.0'
  spec.requires_arc = true
  spec.source_files = 'Source/*.{h,m}'

end
