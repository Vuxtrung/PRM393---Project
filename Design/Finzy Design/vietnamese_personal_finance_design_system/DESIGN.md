---
name: Vietnamese Personal Finance Design System
colors:
  surface: '#f7faf9'
  surface-dim: '#d7dbda'
  surface-bright: '#f7faf9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f4f3'
  surface-container: '#ebeeee'
  surface-container-high: '#e6e9e8'
  surface-container-highest: '#e0e3e2'
  on-surface: '#181c1c'
  on-surface-variant: '#3e4948'
  inverse-surface: '#2d3131'
  inverse-on-surface: '#eef1f0'
  outline: '#6e7979'
  outline-variant: '#bec9c8'
  surface-tint: '#016a6a'
  primary: '#005454'
  on-primary: '#ffffff'
  primary-container: '#0d6e6e'
  on-primary-container: '#9dedec'
  inverse-primary: '#84d4d3'
  secondary: '#835500'
  on-secondary: '#ffffff'
  secondary-container: '#feae2c'
  on-secondary-container: '#6b4500'
  tertiary: '#743c1d'
  on-tertiary: '#ffffff'
  tertiary-container: '#915332'
  on-tertiary-container: '#ffd8c6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#a0f0f0'
  primary-fixed-dim: '#84d4d3'
  on-primary-fixed: '#002020'
  on-primary-fixed-variant: '#004f50'
  secondary-fixed: '#ffddb4'
  secondary-fixed-dim: '#ffb955'
  on-secondary-fixed: '#291800'
  on-secondary-fixed-variant: '#633f00'
  tertiary-fixed: '#ffdbcb'
  tertiary-fixed-dim: '#ffb692'
  on-tertiary-fixed: '#341100'
  on-tertiary-fixed-variant: '#6f3819'
  background: '#f7faf9'
  on-background: '#181c1c'
  surface-variant: '#e0e3e2'
typography:
  display-currency:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Be Vietnam Pro
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
  headline-lg-mobile:
    fontFamily: Be Vietnam Pro
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 16px
  margin-desktop: 24px
  gutter: 16px
---

## Brand & Style
This design system is tailored for Vietnamese millennials, bridging the gap between professional fintech reliability and the friendly, accessible nature of local lifestyle apps. The brand personality is **Trustworthy yet Approachable**, removing the intimidation factor from financial management while maintaining the precision required for money tracking.

The visual style is **Corporate Modern with a Soft Edge**, taking inspiration from high-end digital banking (Nubank) and local wallet ecosystems (Momo). It prioritizes clarity and speed of entry, using a "card-based" architecture to organize financial data into digestible modules. The emotional response should be one of "Financial Calm"—making the user feel in control rather than overwhelmed by their spending.

## Colors
The palette uses **Deep Teal** as the foundation to evoke stability and growth. **Amber** serves as a strategic accent color for call-to-actions and "nudge" notifications, such as savings goals or budget alerts.

- **Semantic Logic:** Success Green and Danger Red are used exclusively for financial status (Income vs. Expense) and system validation.
- **Surface Strategy:** In Light Mode, surfaces use pure white against a cool gray-blue background to create a crisp, layered effect. In Dark Mode, surfaces are slightly lifted midnight blues to maintain depth without losing readability.
- **Currency Highlighting:** Transaction amounts must strictly follow the semantic color coding: positive balances in Success Green, negative in Danger Red.

## Typography
The system uses **Be Vietnam Pro** for headings to provide a friendly, localized contemporary feel that handles Vietnamese diacritics beautifully. **Inter** is utilized for body text and numbers due to its exceptional legibility in data-heavy environments.

- **Currency Formatting:** All currency must follow the format `1.250.000 ₫`. The `₫` symbol should be the same weight as the digits but may be sized 10% smaller for visual balance.
- **Data Density:** Use `body-md` for transaction lists to maximize the information visible on a single screen.
- **Capitalization:** Labels use uppercase with increased letter spacing to differentiate them from interactive body text.

## Layout & Spacing
The layout follows a **Fluid Grid** model with a focus on mobile-first interaction. 

- **Grid:** On mobile, use a 4-column grid with 16px margins. On tablet/desktop, scale to a 12-column grid centered at a max-width of 1200px.
- **Rhythm:** An 8px linear scale is the primary driver for spacing. Use 16px (`md`) for internal card padding and 24px (`lg`) to separate major logical sections.
- **Safe Areas:** Ensure the bottom navigation bar accounts for the home indicator on modern mobile devices, with a minimum height of 84px to accommodate the 5-tab structure.

## Elevation & Depth
This design system uses **Tonal Layers** combined with **Ambient Shadows** to create a sense of organized hierarchy.

- **Level 0 (Background):** Used for the main app canvas (`#F8FAFB`).
- **Level 1 (Cards):** Pure white surfaces with a soft shadow (`0 2px 12px rgba(0,0,0,0.06)`). This level hosts the majority of content.
- **Level 2 (Modals/Overlays):** Elevated surfaces with a more pronounced shadow (`0 8px 24px rgba(0,0,0,0.12)`) to indicate temporary interaction states.
- **Bottom Nav:** Uses a soft top-border (`1px solid #E2E8F0`) and a backdrop blur (Glassmorphism effect) to remain visible over scrolling content without feeling heavy.

## Shapes
The shape language is purposefully **Rounded** to feel modern and friendly. 

- **Standard Cards:** 16px (`rounded-lg`) for all main content containers.
- **Interactive Elements:** Buttons use 12px for a balanced, approachable look.
- **Chips/Status:** Pill-shaped (20px+) for category tags (e.g., "Ăn uống", "Di chuyển") to distinguish them from clickable buttons.
- **Input Fields:** 12px radius to match button styling for a cohesive form-entry experience.

## Components
- **Buttons:** Primary buttons use the Deep Teal background with White text. Secondary buttons use a light Teal tint with Teal text. Minimum height 48px for touch targets.
- **Chips:** Used for categories. These should have a light-colored fill matching the icon color (e.g., a light orange background for a "Food" icon).
- **Transaction Lists:** A horizontal layout with an icon on the left, Name/Category in the center (stacked), and Amount on the right. Amounts must be bolded.
- **Heo Đất (Savings Goal):** A specialized progress card component featuring a custom "piggy bank" icon and a percentage bar using the Amber accent color.
- **Bottom Navigation:** 5 distinct tabs (Home, Giao dịch, Thống kê, Heo, Tôi). The active state uses the Primary Teal color for the icon and label, while inactive states use a muted gray-blue.
- **Input Fields:** Outlined style with a 1px border. When focused, the border thickens to 2px and changes to the Primary Teal color.
- **Icons:** 24px outlined stroke (1.5px thickness). Use colorful, circular background fills for category icons to aid quick visual recognition.