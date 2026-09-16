#!/usr/bin/env ruby

require "date"
require "yaml"

ROOT = File.expand_path("..", __dir__)
COLLECTIONS = {
  "_talks" => %w[title kind permalink date venue location description],
  "_publications" => %w[title kind permalink date venue description paper_url]
}.freeze
LEGACY_FIELDS = %w[collection category excerpt paperurl slidesurl type].freeze

errors = []
permalinks = {}
counts = Hash.new(0)

COLLECTIONS.each do |directory, required_fields|
  Dir.glob(File.join(ROOT, directory, "*.md")).sort.each do |path|
    relative_path = path.delete_prefix("#{ROOT}/")
    source = File.read(path)
    match = source.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)

    unless match
      errors << "#{relative_path}: missing YAML front matter"
      next
    end

    begin
      data = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
    rescue Psych::SyntaxError => e
      errors << "#{relative_path}: invalid YAML (#{e.problem})"
      next
    end

    counts[directory] += 1

    required_fields.each do |field|
      errors << "#{relative_path}: missing #{field}" if data[field].nil? || data[field].to_s.strip.empty?
    end

    legacy = LEGACY_FIELDS.select { |field| data.key?(field) }
    errors << "#{relative_path}: replace legacy fields: #{legacy.join(', ')}" unless legacy.empty?

    if directory == "_publications" && !%w[paper patent].include?(data["kind"])
      errors << "#{relative_path}: kind must be paper or patent"
    end

    permalink = data["permalink"]
    if permalink
      if permalinks.key?(permalink)
        errors << "#{relative_path}: duplicates permalink from #{permalinks[permalink]}"
      else
        permalinks[permalink] = relative_path
      end
    end

    urls = %w[event_url paper_url slides_url video_url].filter_map { |field| data[field] }
    urls.concat(Array(data["resources"]).filter_map { |resource| resource["url"] })
    urls.grep(%r{\A/}).each do |url|
      local_path = File.join(ROOT, url.delete_prefix("/"))
      errors << "#{relative_path}: local resource does not exist: #{url}" unless File.file?(local_path)
    end
  end
end

if errors.empty?
  puts "Content is valid: #{counts['_talks']} talks, #{counts['_publications']} publications."
else
  warn errors.map { |error| "- #{error}" }.join("\n")
  exit 1
end
