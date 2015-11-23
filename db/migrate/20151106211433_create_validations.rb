class CreateValidations < ActiveRecord::Migration
  def change
    create_table :validations do |t|
      t.references :sample, index: true
      t.boolean :confirmation
      t.string :reference_build
      t.string :chr
      t.string :pos
      t.string :ref
      t.string :alt
      t.string :hgvs_c
      t.string :hgvs_p
      t.string :gene
      t.string :transcript
      t.string :exon
      t.string :primer_forward
      t.string :primer_reverse
      t.integer :pcr_size
      t.float :annealing_temp
      t.string :notes
      t.timestamps
    end
  end
end
