import Foundation

public enum FormValidation {
  public static func email(_ value: String) -> String? {
    let cleaned = value.trimmingCharacters(in: .whitespacesAndNewlines)
    if cleaned.isEmpty { return "Enter your email address." }
    if cleaned.range(of: "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", options: .regularExpression) == nil {
      return "Use an address such as name@example.com."
    }
    return nil
  }
  public static func name(_ value: String) -> String? {
    value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Enter your name." : nil
  }
}
