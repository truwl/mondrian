version development


import "../../workflows/breakpoint_calling/destruct.wdl" as destruct
import "../../workflows/breakpoint_calling/lumpy.wdl" as lumpy
import "../../workflows/breakpoint_calling/gridss.wdl" as gridss
import "../../workflows/breakpoint_calling/svaba.wdl" as svaba



workflow BreakpointWorkflow {
    input {
        File normal_bam
        File tumour_bam
        Directory ref_dir
        Int numThreads
    }

    call lumpy.LumpyWorkflow as lumpy{
        input:
            normal_bam = normal_bam,
            tumour_bam = tumour_bam
    }

    call destruct.DestructWorkflow as destruct{
        input:
            normal_bam = normal_bam,
            tumour_bam = tumour_bam,
            ref_dir = ref_dir,
    }

#    call gridss.GridssWorkflow as gridss{
#        input:
#            normal_bam = normal_bam,
#            tumour_bam = tumour_bam,
#            numThreads = numThreads,
#            reference = reference,
#            reference_fai = reference_fai,
#            reference_amb = reference_amb,
#            reference_sa = reference_sa,
#            reference_bwt = reference_bwt,
#            reference_ann = reference_ann,
#            reference_pac = reference_pac,
#    }
#    call svaba.SvabaWorkflow as svaba{
#        input:
#            normal_bam = normal_bam,
#            tumour_bam = tumour_bam,
#            numThreads = numThreads,
#            reference = reference,
#            reference_fai = reference_fai,
#            reference_amb = reference_amb,
#            reference_sa = reference_sa,
#            reference_bwt = reference_bwt,
#            reference_ann = reference_ann,
#            reference_pac = reference_pac,
#    }
}