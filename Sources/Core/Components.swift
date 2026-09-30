import SwiftUI

public enum DesignTokens {
  public static let spacing: CGFloat = 16
  public static let cornerRadius: CGFloat = 12
  public static let accent = Color(red: 0.22, green: 0.35, blue: 0.57)
}
public struct PrimaryAction: View {
  let title: String
  let loading: Bool
  let enabled: Bool
  let action: () -> Void
  public init(
    _ title: String, loading: Bool = false, enabled: Bool = true, action: @escaping () -> Void
  ) {
    self.title = title
    self.loading = loading
    self.enabled = enabled
    self.action = action
  }
  public var body: some View {
    Button(action: action) {
      HStack {
        if loading { ProgressView().tint(.white) }
        Text(loading ? "Working…" : title).font(.headline).multilineTextAlignment(.center)
      }.frame(maxWidth: .infinity, minHeight: 44).padding(.horizontal, 12).padding(.vertical, 4)
    }.buttonStyle(.borderedProminent).tint(DesignTokens.accent).disabled(!enabled || loading)
      .accessibilityLabel(loading ? "\(title), in progress" : title)
  }
}
public struct StatusMessage: View {
  public enum Kind { case information, error, success }
  let title: String, message: String, kind: Kind
  public init(_ title: String, message: String, kind: Kind = .information) {
    self.title = title
    self.message = message
    self.kind = kind
  }
  private var symbol: String {
    kind == .error
      ? "exclamationmark.circle" : kind == .success ? "checkmark.circle" : "info.circle"
  }
  public var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: symbol).accessibilityHidden(true)
      VStack(alignment: .leading, spacing: 6) {
        Text(title).font(.headline)
        Text(message).font(.subheadline).fixedSize(horizontal: false, vertical: true)
      }
    }.padding(16).frame(maxWidth: .infinity, alignment: .leading).background(
      DesignTokens.accent.opacity(0.08)
    ).cornerRadius(DesignTokens.cornerRadius).accessibilityElement(children: .combine)
  }
}
public struct LabeledField: View {
  let title: String, hint: String, error: String?
  @Binding var text: String
  public init(_ title: String, text: Binding<String>, hint: String = "", error: String? = nil) {
    self.title = title
    self._text = text
    self.hint = hint
    self.error = error
  }
  public var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(title).font(.subheadline.weight(.semibold))
      TextField(title, text: $text).textFieldStyle(.roundedBorder).frame(minHeight: 44)
        .accessibilityLabel(title).accessibilityHint(error ?? hint)
      if let error {
        Label(error, systemImage: "exclamationmark.circle").font(.caption).fixedSize(
          horizontal: false, vertical: true)
      } else if !hint.isEmpty {
        Text(hint).font(.caption).foregroundColor(.secondary).fixedSize(
          horizontal: false, vertical: true)
      }
    }
  }
}
public struct EmptyState: View {
  let title: String, message: String, symbol: String
  public init(_ title: String, message: String, symbol: String = "tray") {
    self.title = title
    self.message = message
    self.symbol = symbol
  }
  public var body: some View {
    VStack(spacing: 12) {
      Image(systemName: symbol).font(.largeTitle).accessibilityHidden(true)
      Text(title).font(.title2.weight(.semibold))
      Text(message).font(.body).foregroundColor(.secondary).multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }.padding(24).frame(maxWidth: .infinity).accessibilityElement(children: .combine)
  }
}
public struct SettingsRow: View {
  let title: String, detail: String, symbol: String
  public init(_ title: String, detail: String, symbol: String) {
    self.title = title
    self.detail = detail
    self.symbol = symbol
  }
  public var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Image(systemName: symbol).frame(width: 28).accessibilityHidden(true)
      VStack(alignment: .leading, spacing: 5) {
        Text(title).font(.headline)
        Text(detail).font(.subheadline).foregroundColor(.secondary).fixedSize(
          horizontal: false, vertical: true)
      }
      Spacer(minLength: 8)
      Image(systemName: "chevron.forward").font(.caption).accessibilityHidden(true)
    }.padding(.vertical, 8).frame(minHeight: 44).accessibilityElement(children: .combine)
  }
}
