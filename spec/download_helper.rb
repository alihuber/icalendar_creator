module DownloadHelper
  TIMEOUT = 10

  extend self

  def downloads
    Dir.glob(Dir.pwd + "/tmp/*")
  end

  def download
    downloads.first
  end

  def download_content
    wait_for_download
    file = File.open(download, "r")
    content = file.read
    file.close
    content
  end

  def wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  def downloaded?
    !downloading? && downloads.any?
  end

  def downloading?
    downloads.grep(/\.icalendar$/).any?
  end

  def clear_downloads
    downloads.each do |file|
      File.delete(file)
    end
  end
end
