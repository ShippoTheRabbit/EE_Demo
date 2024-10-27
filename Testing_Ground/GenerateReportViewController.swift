import UIKit
import PDFKit

class GenerateReportViewController: UIViewController {
    var selectedEntries: [ScoreViewController.SurveyEntry] = []
    var tableViewsToCapture: [UITableView] = []  // Store references to multiple table views

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("GenerateReportViewController loaded. Number of selected entries: \(selectedEntries.count)")
        generatePDFReport()
    }

    func generatePDFReport() {
        let pdfMetaData = [
            kCGPDFContextCreator as String: "EGID Tracker",
            kCGPDFContextTitle as String: "Combined Report"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData

        let pageWidth = 8.5 * 72.0  // 8.5 inches by 72 points/inch
        let pageHeight = 11 * 72.0  // 11 inches by 72 points/inch
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in
            var pageNumber = 1
            context.beginPage()
            drawHeader(pageRect: pageRect, pageNumber: pageNumber)
            
            // Capture table view snapshots and insert them into the PDF
            for tableView in tableViewsToCapture {
                if let tableViewImage = captureTableViewSnapshot(from: tableView) {
                    let imageRect = CGRect(x: 20, y: 120, width: pageRect.width - 40, height: pageRect.height - 200)
                    tableViewImage.draw(in: imageRect)
                    context.beginPage() // Start a new page for each table view
                }
            }

            drawFooter(pageRect: pageRect, pageNumber: pageNumber)
        }

        let fileURL = getDocumentsDirectory().appendingPathComponent("CombinedReport.pdf")
        do {
            try data.write(to: fileURL)
            print("PDF saved at: \(fileURL)")
            sharePDF(fileURL: fileURL)
        } catch {
            print("Could not save PDF: \(error.localizedDescription)")
        }
    }

    func captureTableViewSnapshot(from tableView: UITableView) -> UIImage? {
        // Capture the full content of the table view (even offscreen rows)
        UIGraphicsBeginImageContextWithOptions(tableView.contentSize, false, 0.0)
        let savedContentOffset = tableView.contentOffset
        tableView.contentOffset = .zero  // Scroll to the top to capture the full table
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        tableView.contentOffset = savedContentOffset  // Restore the original offset
        UIGraphicsEndImageContext()

        return image
    }

    func drawHeader(pageRect: CGRect, pageNumber: Int) {
        let title = "Combined Survey Report"
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let titleRect = CGRect(x: 20, y: 40, width: pageRect.width - 40, height: 40)
        title.draw(in: titleRect, withAttributes: attributes)

        let pageNumberText = "Page \(pageNumber)"
        let pageNumberAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        let pageNumberRect = CGRect(x: pageRect.width - 80, y: 40, width: 60, height: 20)
        pageNumberText.draw(in: pageNumberRect, withAttributes: pageNumberAttributes)
    }

    func drawFooter(pageRect: CGRect, pageNumber: Int) {
        let footerText = "Generated by EGID Tracker"
        let attributes = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 12)]
        let footerRect = CGRect(x: 20, y: pageRect.height - 40, width: pageRect.width - 40, height: 20)
        footerText.draw(in: footerRect, withAttributes: attributes)

        let pageNumberText = "Page \(pageNumber)"
        let pageNumberRect = CGRect(x: pageRect.width - 80, y: pageRect.height - 40, width: 60, height: 20)
        pageNumberText.draw(in: pageNumberRect, withAttributes: attributes)
    }

    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func sharePDF(fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .postToFacebook,
            .postToTwitter
        ]

        present(activityViewController, animated: true) {
            print("PDF sharing options presented.")
        }
    }
}
