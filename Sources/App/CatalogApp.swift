import SwiftUI

@main struct CatalogApp: App {
  var body: some Scene { WindowGroup { CatalogView().tint(DesignTokens.accent) } }
}
struct CatalogView: View {
  @State var large = false
  @State var rtl = false
  @State var dark = false
  var body: some View {
    NavigationView {
      List {
        Section {
          VStack(alignment: .leading, spacing: 8) {
            Text("Built to include.").font(.title.weight(.semibold))
            Text(
              "A small SwiftUI component library with readable type, meaningful labels, and room for larger text."
            ).foregroundColor(.secondary)
          }.padding(.vertical, 8)
        }
        Section("Components") {
          NavigationLink {
            FormDemo()
          } label: {
            SettingsRow(
              "Forms", detail: "Labels, validation, and focus",
              symbol: "rectangle.and.pencil.and.ellipsis")
          }
          NavigationLink {
            StatesDemo()
          } label: {
            SettingsRow(
              "UI states", detail: "Loading, empty, error, and success", symbol: "square.stack")
          }
          NavigationLink {
            ListDemo()
          } label: {
            SettingsRow(
              "Lists and navigation", detail: "Rows that adapt to content", symbol: "list.bullet")
          }
        }
        Section("Preview settings") {
          Toggle("Accessibility text size", isOn: $large)
          Toggle("Right-to-left layout", isOn: $rtl)
          Toggle("Dark appearance", isOn: $dark)
          Text(
            "Preview settings apply to this catalog. Use system Settings for VoiceOver, Increase Contrast, and the full range of text sizes."
          ).font(.footnote).foregroundColor(.secondary)
        }
        Section("Design decisions") {
          Text(
            "System type styles. Leading alignment. Minimum 44-point actions. Errors described in words. No fixed text heights or information conveyed by colour alone."
          ).font(.subheadline)
        }
      }.listStyle(.insetGrouped).navigationTitle("Design Catalog")
    }.navigationViewStyle(.stack)
      .environment(\.sizeCategory, large ? .accessibilityExtraExtraExtraLarge : .large)
      .environment(\.layoutDirection, rtl ? .rightToLeft : .leftToRight)
      .preferredColorScheme(dark ? .dark : .light)
  }
}
struct FormDemo: View {
  @State var name = ""
  @State var email = ""
  @State var submitted = false
  @State var saved = false
  @State var busy = false
  @FocusState var focus: Field?
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  enum Field: Hashable { case name, email }
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        Text("Create your profile").font(.largeTitle.weight(.semibold))
        Text("This is a local example. Your details are never submitted to a server.")
          .foregroundColor(.secondary)
        LabeledField("Name", text: $name, error: submitted ? FormValidation.name(name) : nil)
          .focused($focus, equals: .name).textContentType(.name)
        LabeledField(
          "Email", text: $email, hint: "We use this for your account.",
          error: submitted ? FormValidation.email(email) : nil
        ).focused($focus, equals: .email).keyboardType(.emailAddress).textInputAutocapitalization(
          .never
        ).textContentType(.emailAddress)
        if submitted && (FormValidation.name(name) != nil || FormValidation.email(email) != nil) {
          StatusMessage(
            "Check your details", message: "Correct the fields above to continue.", kind: .error)
        }
        if saved {
          StatusMessage(
            "Profile preview saved", message: "Your form passed local validation.", kind: .success)
        }
        PrimaryAction("Save profile", loading: busy) {
          submitted = true
          saved = false
          if FormValidation.name(name) != nil {
            focus = .name
          } else if FormValidation.email(email) != nil {
            focus = .email
          } else {
            focus = nil
            busy = true
            Task {
              try? await Task.sleep(nanoseconds: 600_000_000)
              busy = false
              saved = true
              UIAccessibility.post(notification: .announcement, argument: "Profile preview saved")
            }
          }
        }
      }.padding(24).frame(maxWidth: 640).frame(maxWidth: .infinity)
    }.navigationTitle("Forms").navigationBarTitleDisplayMode(.inline)
  }
}
struct StatesDemo: View {
  @State var retry = false
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        Text("Useful at every step.").font(.title.weight(.semibold))
        EmptyState(
          "No saved items",
          message:
            "Items you save will appear here. Browse the collection to find something you like.",
          symbol: "bookmark")
        StatusMessage(
          "Connection unavailable",
          message: "Your saved items are still available. Try again when you’re online.",
          kind: .error)
        PrimaryAction("Retry", loading: retry) {
          retry = true
          Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            retry = false
          }
        }
        StatusMessage(
          "Changes saved", message: "Your latest edits are stored on this device.", kind: .success)
        StatusMessage(
          "About this preview",
          message: "Retry demonstrates a local loading state; it does not make a network request.")
      }.padding(24).frame(maxWidth: 640).frame(maxWidth: .infinity)
    }.navigationTitle("UI states").navigationBarTitleDisplayMode(.inline)
  }
}
struct ListDemo: View {
  var body: some View {
    List {
      Section("Preferences") {
        NavigationLink {
          Text("Notification preferences would appear here.").padding().navigationTitle(
            "Notifications")
        } label: {
          SettingsRow("Notifications", detail: "Choose which updates matter to you", symbol: "bell")
        }
        NavigationLink {
          Text("Your device keeps local preview settings.").padding().navigationTitle("Privacy")
        } label: {
          SettingsRow(
            "Privacy and data", detail: "Control what is stored and shared", symbol: "lock.shield")
        }
      }
      Section {
        Text(
          "Rows wrap at larger sizes. The disclosure symbol follows the layout direction; decorative icons are hidden from VoiceOver."
        ).font(.footnote).foregroundColor(.secondary)
      }
    }.navigationTitle("Lists").navigationBarTitleDisplayMode(.inline)
  }
}
