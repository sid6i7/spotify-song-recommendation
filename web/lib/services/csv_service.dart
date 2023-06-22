import 'dart:html' as html;

class CsvService {
  void initiateFileDownload(String csvData) {
    final encodedData = Uri.encodeComponent(csvData);
    final dataUrl = 'data:text/csv;charset=utf-8,$encodedData';
    final anchorElement = html.AnchorElement(href: dataUrl);
    anchorElement.download = 'playlist.csv';
    anchorElement.click();
  }
}
