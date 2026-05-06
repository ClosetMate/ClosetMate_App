class DynamicSection {
  final String type;
  final String title;
  final bool enabled;
  final int order;
  final Map<String, dynamic> config;

  DynamicSection({
    required this.type,
    required this.title,
    required this.enabled,
    required this.order,
    required this.config,
  });

  factory DynamicSection.fromConfig(Map<String, dynamic> config) {
    return DynamicSection(
      type: config['type'] ?? '',
      title: config['title'] ?? '',
      enabled: config['enabled'] ?? true,
      order: config['order'] ?? 0,
      config: config['config'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'enabled': enabled,
      'order': order,
      'config': config,
    };
  }
}

class HomeLayout {
  final List<DynamicSection> sections;
  final Map<String, dynamic> theme;
  final Map<String, dynamic> features;

  HomeLayout({
    required this.sections,
    required this.theme,
    required this.features,
  });

  factory HomeLayout.fromConfig(Map<String, dynamic> config) {
    List<DynamicSection> sections = [];
    if (config['sections'] != null) {
      sections = (config['sections'] as List)
          .map((section) => DynamicSection.fromConfig(section))
          .toList();
      sections.sort((a, b) => a.order.compareTo(b.order));
    }

    return HomeLayout(
      sections: sections,
      theme: config['theme'] ?? {},
      features: config['features'] ?? {},
    );
  }
} 