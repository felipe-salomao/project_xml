class Reports::ImportZip
  attr_accessor :zip_file

  def initialize(zip_file)
    @zip_file = zip_file
  end

  def execute
    return if zip_file.blank?

    mount_zip
  end

  private

  def mount_zip
    Zip::File.open(zip_file.path) do |file|
      file.each do |entry|
        next unless entry.file? && entry.name.end_with?('.xml')
  
        tmp_dir = Rails.root.join('tmp')
        file_path = File.join(tmp_dir, entry.name)

        entry.extract(file_path)
  
        report = Report.create!(xml_file: File.open(file_path))
  
        ProcessXmlJob.perform_async(report.id)
      end
    end
  end
end
