module Coltrane
  # It describe the quality of a chord, like maj7 or dim.
  class ChordQuality
    attr_reader :name

    CHORD_QUALITIES = {
      'M'    => [0, 4, 7],
      ''     => [0, 4, 7],
      'm'    => [0, 3, 7],
      '+'    => [0, 4, 8],
      'dim'  => [0, 4, 6],
      'dim7' => [0, 3, 6, 11],
      'm7b5' => [0, 3, 6, 10],
      'min7' => [0, 3, 7, 10],
      'mM7'  => [0, 3, 7, 11],
      '7'    => [0, 4, 7, 10],
      '+7'   => [0, 3, 8, 10],
      '+M7'  => [0, 4, 8, 11]
    }.freeze

    def initialize(interval_sequence)
      if interval_sequence.class != IntervalSequence
        interval_sequence = IntervalSequence.new(interval_sequence)
      end
      @name = find_chord_name(interval_sequence)
    end

    def self.new_from_notes(notes)
      note_set = NoteSet.new(notes) unless notes.class == NoteSet
      new(note_set.interval_sequence)
    end

    def self.new_from_pitches(*pitches)
      notes = pitches.sort_by(&:number)
                     .collect(&:note)
                     .collect(&:name)
                     .uniq

      new_from_notes(notes)
    end

    def self.new_from_string(quality_string)
      new(CHORD_QUALITIES[quality_string])
    end

    def intervals
      CHORD_QUALITIES[name]
    end

    protected

    def find_chord_name(note_intervals, inversion = 0)
      inversion >= note_intervals.all.size && return
      CHORD_QUALITIES.key(note_intervals.numbers) ||
        CHORD_QUALITIES.key(note_intervals.numbers.sort) ||
        find_chord_name(note_intervals.next_inversion, inversion + 1) ||
        "(#{note_intervals.numbers.sort.join(' ')})"
    end
  end
end