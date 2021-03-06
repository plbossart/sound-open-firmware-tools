# Low Latency Passthrough Pipeline and PCM
#
# Pipeline Endpoints for connection are :-
#
#  host PCM_P --> B0 --> sink DAI0

# Include topology builder
include(`utils.m4')
include(`buffer.m4')
include(`pcm.m4')
include(`dai.m4')
include(`pipeline.m4')

#
# Components and Buffers
#

# Host "Passthrough Playback" PCM uses pipeline DMAC and channel
# with 2 sink and 0 source periods
W_PCM_PLAYBACK(Passthrough Playback, PIPELINE_DMAC, PIPELINE_DMAC_CHAN, 2, 0, 2)

# Playback Buffers
W_BUFFER(0, COMP_BUFFER_SIZE(2,
	COMP_SAMPLE_SIZE(PIPELINE_FORMAT), PIPELINE_CHANNELS, SCHEDULE_FRAMES),
	PLATFORM_PASS_MEM_CAP)

#
# DAI definitions
#
W_DAI_OUT(DAI_TYPE, DAI_INDEX, DAI_FORMAT, 0, 2, 2, dai0p_plat_conf)

#
# DAI pipeline - always use 0 for DAIs
#
W_PIPELINE(N_DAI_OUT, SCHEDULE_DEADLINE, SCHEDULE_PRIORITY, SCHEDULE_FRAMES, SCHEDULE_CORE, 0, pipe_dai_schedule_plat)

#
# Pipeline Graph
#
#  host PCM_P --> B0 --> sink DAI0

P_GRAPH(pipe-pass-playback-PIPELINE_ID, PIPELINE_ID,
	LIST(`		',
	`dapm(N_PCMP, Passthrough Playback PCM_ID)',
	`dapm(N_BUFFER(0), N_PCMP)'))

#
# Pipeline Source and Sinks
#
indir(`define', concat(`PIPELINE_SOURCE_', PIPELINE_ID), N_BUFFER(0))
indir(`define', concat(`PIPELINE_PCM_', PIPELINE_ID), Passthrough Playback PCM_ID)

#
# PCM Configuration
#

PCM_CAPABILITIES(Passthrough Playback PCM_ID, `S32_LE,S24_LE,S16_LE', 48000, 48000, 2, 4, 2, 16, 192, 16384, 65536, 65536)
