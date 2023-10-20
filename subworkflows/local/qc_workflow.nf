//
// Check input samplesheet and get read channels
//

include { PICARD_COLLECTRNASEQMETRICS }                from '../../modules/local/picard/collectrnaseqmetrics/main'
include { PICARD_MARKDUPLICATES }                      from '../../modules/nf-core/picard/markduplicates/main'

workflow QC_WORKFLOW {
    take:
        ch_bam_sorted
        ch_bam_sorted_indexed
        ch_chrgtf
        ch_refflat
        ch_fasta
        ch_fai
        ch_rrna_interval
        ch_rrna_intervals_bed

    main:
        ch_versions = Channel.empty()

        PICARD_COLLECTRNASEQMETRICS(ch_bam_sorted_indexed, ch_refflat, ch_rrna_interval)
        ch_versions = ch_versions.mix(PICARD_COLLECTRNASEQMETRICS.out.versions)
        ch_rnaseq_metrics = Channel.empty().mix(PICARD_COLLECTRNASEQMETRICS.out.metrics)

        PICARD_MARKDUPLICATES(ch_bam_sorted, ch_fasta, ch_fai)
        ch_versions = ch_versions.mix(PICARD_MARKDUPLICATES.out.versions)
        ch_duplicate_metrics = Channel.empty().mix(PICARD_MARKDUPLICATES.out.metrics)


    emit:
        versions            = ch_versions.ifEmpty(null)
        rnaseq_metrics      = ch_rnaseq_metrics
        duplicate_metrics   = ch_duplicate_metrics

}

