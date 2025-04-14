import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/proposal.dart';
import '../widgets/custom_card.dart';

class ProposalCard extends StatelessWidget {
  final Proposal proposal;
  final VoidCallback? onViewDetails;
  final VoidCallback? onVote;
  final VoidCallback? onExecute;

  const ProposalCard({
    super.key,
    required this.proposal,
    this.onViewDetails,
    this.onVote,
    this.onExecute,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildDescription(),
          const SizedBox(height: 16),
          _buildVotingProgress(),
          const SizedBox(height: 16),
          _buildTimeInfo(),
          const SizedBox(height: 16),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proposal.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Created by ${proposal.creator}',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (proposal.status) {
      case ProposalStatus.active:
        backgroundColor = Colors.blue.withValues(alpha: 0.2 * 255);
        textColor = Colors.blue;
        statusText = 'ACTIVE';
        break;
      case ProposalStatus.passed:
        backgroundColor = Colors.green.withValues(alpha: 0.2 * 255);
        textColor = Colors.green;
        statusText = 'PASSED';
        break;
      case ProposalStatus.rejected:
        backgroundColor = Colors.red.withValues(alpha: 0.2 * 255);
        textColor = Colors.red;
        statusText = 'REJECTED';
        break;
      case ProposalStatus.pending:
        backgroundColor = Colors.orange.withValues(alpha: 0.2 * 255);
        textColor = Colors.orange;
        statusText = 'PENDING';
        break;
      case ProposalStatus.executed:
        backgroundColor = Colors.purple.withValues(alpha: 0.2 * 255);
        textColor = Colors.purple;
        statusText = 'EXECUTED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      proposal.description,
      style: const TextStyle(fontSize: 14),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildVotingProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Voting Progress',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              'Quorum: ${proposal.quorumPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: proposal.hasQuorum ? Colors.green : Colors.grey[400],
                fontSize: 12,
                fontWeight:
                    proposal.hasQuorum ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 8,
                  width: proposal.forPercentage * 3,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(4),
                      bottomLeft: const Radius.circular(4),
                      topRight:
                          proposal.againstPercentage == 0 &&
                                  proposal.abstainPercentage == 0
                              ? const Radius.circular(4)
                              : Radius.zero,
                      bottomRight:
                          proposal.againstPercentage == 0 &&
                                  proposal.abstainPercentage == 0
                              ? const Radius.circular(4)
                              : Radius.zero,
                    ),
                  ),
                ),
                Container(
                  height: 8,
                  width: proposal.againstPercentage * 3,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                        proposal.forPercentage == 0
                            ? BorderRadius.only(
                              topLeft: const Radius.circular(4),
                              bottomLeft: const Radius.circular(4),
                              topRight:
                                  proposal.abstainPercentage == 0
                                      ? const Radius.circular(4)
                                      : Radius.zero,
                              bottomRight:
                                  proposal.abstainPercentage == 0
                                      ? const Radius.circular(4)
                                      : Radius.zero,
                            )
                            : null,
                  ),
                ),
                Container(
                  height: 8,
                  width: proposal.abstainPercentage * 3,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                        proposal.forPercentage == 0 &&
                                proposal.againstPercentage == 0
                            ? BorderRadius.circular(4)
                            : BorderRadius.only(
                              topRight: const Radius.circular(4),
                              bottomRight: const Radius.circular(4),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildVoteLabel(
              'For',
              proposal.votingPowerFor,
              proposal.forPercentage,
              Colors.green,
            ),
            _buildVoteLabel(
              'Against',
              proposal.votingPowerAgainst,
              proposal.againstPercentage,
              Colors.red,
            ),
            _buildVoteLabel(
              'Abstain',
              proposal.votingPowerAbstain,
              proposal.abstainPercentage,
              Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoteLabel(
    String label,
    double power,
    double percentage,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: ${percentage.toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 12, color: Colors.grey[300]),
        ),
      ],
    );
  }

  Widget _buildTimeInfo() {
    final now = DateTime.now();
    final isActive = proposal.status == ProposalStatus.active;

    String timeText;
    if (isActive) {
      final remaining = proposal.endTime.difference(now);
      if (remaining.inDays > 0) {
        timeText = 'Ends in ${remaining.inDays} days';
      } else if (remaining.inHours > 0) {
        timeText = 'Ends in ${remaining.inHours} hours';
      } else {
        timeText = 'Ends in ${remaining.inMinutes} minutes';
      }
    } else {
      final ended = now.difference(proposal.endTime);
      if (ended.inDays > 0) {
        timeText = 'Ended ${ended.inDays} days ago';
      } else if (ended.inHours > 0) {
        timeText = 'Ended ${ended.inHours} hours ago';
      } else {
        timeText = 'Ended ${ended.inMinutes} minutes ago';
      }
    }

    return Row(
      children: [
        Icon(
          isActive ? Icons.timer : Icons.timer_off,
          size: 16,
          color: Colors.grey[400],
        ),
        const SizedBox(width: 4),
        Text(timeText, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onViewDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cardColor,
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppTheme.primaryColor, width: 1),
              ),
            ),
            child: const Text('View Details'),
          ),
        ),
        if (proposal.status == ProposalStatus.active) ...[
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onVote,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Vote'),
            ),
          ),
        ],
        if (proposal.status == ProposalStatus.passed &&
            proposal.executionData != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: onExecute,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Execute'),
            ),
          ),
        ],
      ],
    );
  }
}
